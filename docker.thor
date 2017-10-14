#!/usr/bin/ruby

require "thor"
require "pty"
require "rainbow"

class Docker < Thor
  class_option :env, default: "dev", type: :string

  PROJECT = "homepage".freeze

  desc "build", "Build images. Pass image name to build a specific one; otherwise builds all"
  def build(*images)
    images = versions.keys if images.empty?
    images = Array(images)
    env    = options[:env]

    puts "Generating build script for #{images.join(", ")}"
    commands = []

    images.each do |image|
      version    = versions[image]
      tag        = "jutonz/#{PROJECT}-#{env}-#{image}:#{version}"
      dockerfile = "docker/#{env}/#{image}/Dockerfile"

      commands << "#{sudo}docker #{docker_opts} build -f #{dockerfile} -t #{tag} ."
    end

    stream_output commands.join(" && "), exec: true
  end

  desc "push", "Upload locally built images to the remote store"
  def push(*images)
    images = versions.keys if images.empty?
    images = Array(images)
    env    = options[:env]

    push_cmds = []

    images.each do |image|
      version = versions[image]
      tag_cmd = "#{sudo}docker tag jutonz/#{PROJECT}-#{env}-#{image}:#{version} jutonz/#{PROJECT}-#{env}-#{image}:latest"
      puts tag_cmd
      `#{tag_cmd}`

      push_cmds << "#{sudo}docker push jutonz/#{PROJECT}-#{env}-#{image}:#{version}"
    end

    push_cmd = push_cmds.join " && "
    stream_output push_cmd, exec: true
  end

  desc "pull", "Pull the latest remote images to your local machine"
  def pull(*images)
    images = versions.keys if images.empty?
    images = Array(images)
    env    = options[:env]

    pull_cmds = []

    images.each do |image|
      version = versions[image]
      pull_cmds << "#{sudo}docker pull jutonz/#{PROJECT}-#{env}-#{image}:#{version}"
    end

    pull_cmd = pull_cmds.join " && "
    stream_output pull_cmd, exec: true
  end

  desc "up", "Start your dockerized app server"
  def up
    pidfile = "tmp/pids/server.pid"
    FileUtils.rm pidfile if File.exist? pidfile

    compose_opts = %w(--remove-orphans)
    stream_output "#{sudo}docker-compose -f #{compose_file_path} up #{compose_opts.join(" ")}", exec: true
  end

  desc "down", "Stop your dockerized app server"
  def down
    stream_output "#{sudo}docker-compose -f #{compose_file_path} down", exec: true
  end

  desc "rm", "Remove any stuck containers."
  def rm
    stream_output "#{sudo}docker-compose -f #{compose_file_path} rm", exec: true
  end

  desc "initdb", "Setup initial postgres database"
  def initdb
    env = options[:env]
    local_data_dir = File.expand_path "../tmp/psql-#{env}", __FILE__
    `#{sudo}rm -r #{local_data_dir}` if File.exists? local_data_dir # todo prompt

    cmd = "#{sudo}docker-compose -f #{compose_file_path} run --rm psql /bin/bash -c /etc/initdb.sh"

    stream_output cmd, exec: true
  end

  desc "cleanup", "cleans up dangling docker images"
  def cleanup
    dangling = `#{sudo}docker images --filter dangling=true -q`.split("\n")

    if dangling.none?
      puts "No images to cleanup. Yay!"
      exit 0
    end

    stream_output "#{sudo}docker rmi -f #{dangling.join(" ")}", exec: true
  end

  desc "bash CONTAINER", "Create a new instance of the given image with a bash prompt"
  def bash(container = "app")
    cmd = "#{sudo}docker-compose -f #{compose_file_path} run --rm #{container} /bin/bash"

    stream_output cmd, exec: true
  end

  desc "connect CONTAINER", "Connect to a running container."
  def connect(image = "app")
    stream_output "#{sudo}docker-compose -f #{compose_file_path} exec #{image} /bin/bash", exec: true
  end

  desc "attach CONTAINER", "Connect to a running container."
  option :env, type: :string, default: "dev"
  def attach(image = "app")
    env     = options[:env]
    version = versions[image]
    image   = "jutonz/#{PROJECT}-#{env}-#{image}:#{version}"

    cmd = "#{sudo}docker ps --filter ancestor=#{image} -aq | head -n1"
    puts cmd
    container = `#{cmd}`.chomp

    if container.empty?
      puts Rainbow("No running containers for image #{image}").red
      exit 1
    end

    stream_output "#{sudo}docker attach #{container}", exec: true
  end

  no_commands do
    def stream_output(string, print_command: true, exec: false)
      puts string if print_command
      if exec
        exec string
      else
        PTY.spawn string do |stdout, stdin, pid|
          stdout.each { |line| puts line }
        end
      end
    end

    def sudo
      `uname`.chomp == "Darwin" ? "" : "sudo " # use sudo on linux hosts
    end

    def docker_opts
      return "" unless ENV["JENKINS"]
      opts = "--tls"

      if host = ENV["DOCKER_HOST_IP"]
        opts += " --host tcp://#{host}"
      end

      opts
    end

    def compose_file_path(env: options[:env])
      path = File.expand_path "docker/#{env}/docker-compose.yml"

      unless File.exist? path
        err = "There is no docker compose file for env #{env} (I expected to find it at #{path})"
        puts Rainbow(err).red
        exit 1
      end

      path
    end

    def versions(env: options[:env])
      @versions ||= begin
        compose_file = compose_file_path env: env
        parsed = YAML.load_file compose_file
        images = parsed["services"].keys
        version_map = {}

        images.each do |image|
          version_map[image] = parsed["services"][image]["image"].split(":").last
        end

        version_map
      end
    end
  end
end
