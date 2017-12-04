import * as THREE from "three";
import Globals from "./style-globals";

export default class _BgGrid {
  scene: any;
  camera: any;
  renderer: any;
  geometry: any;
  material: any;
  mesh: any;
  running: boolean;

  constructor() {
    this.scene = null;
    this.camera = null;
    this.renderer = null;
    this.geometry = null;
    this.material = null;
    this.mesh = null;
    this.running = false;
  }

  public init() {
    this.initPlane();
    window.addEventListener('resize', () => {
      this.recalculateRenderingDimensions()
    });
  }

  start() {
    this.running = true;
    this.animatePlane();
  }

  stop() {
    this.running = false;
  }

  initPlane() {
    let innerHeight = window.innerHeight;
    let innerWidth = window.innerWidth;

    this.scene = new THREE.Scene();

    let aspect = innerWidth / innerHeight;
    this.camera = new THREE.PerspectiveCamera(75, aspect, 1, 10000);
    this.camera.position.z = 500;

    const segmentSize = 75; // each segment is segmentSize x segmentSize big
    let geoWidth = innerWidth * 10;
    let geoHeight = innerHeight * 5;
    let widthSegments = geoWidth / segmentSize;
    let heightSegments = geoHeight / segmentSize;
    this.geometry = new THREE.PlaneGeometry(geoWidth, geoHeight, widthSegments, heightSegments);
    this.material = new THREE.MeshBasicMaterial({
      wireframe: true,
      color: Globals.brandPrimary
    });

    this.mesh = new THREE.Mesh(this.geometry, this.material);
    this.mesh.rotation.x = 5.6;
    this.mesh.rotation.y = 3.0;
    this.mesh.rotation.z = 0.4;
    this.scene.add(this.mesh);

    let canvas = document.getElementById('gl-canvas') as HTMLCanvasElement;
    this.renderer = new THREE.WebGLRenderer({ canvas: canvas });
    this.recalculateRenderingDimensions();
    this.renderer.render(this.scene, this.camera);
  }

  animatePlane(ts?: any) {
    if (this.running) {
      requestAnimationFrame(ts => this.animatePlane(ts));
      this.updateWave(ts);
      this.renderer.render(this.scene, this.camera);
    }
  }

  updateWave(ts: any) {
    for(let i = 0; i < this.mesh.geometry.vertices.length; i++) {
      let vertice = this.mesh.geometry.vertices[i]
      let distance = new THREE.Vector2(vertice.x, vertice.y).sub(new THREE.Vector2(0, 0))
      let size = 10;
      let magnitude = 3;
      vertice.z = Math.sin(distance.length() / size + (ts/500)) * magnitude
    }

    this.mesh.geometry.verticesNeedUpdate = true
  }

  recalculateRenderingDimensions() {
    let innerHeight = window.innerHeight;
    let innerWidth = window.innerWidth;
    this.renderer.setSize(innerWidth, innerHeight);

    let aspect = innerWidth / innerHeight;
    this.camera.aspect = aspect;
    this.renderer.setPixelRatio(window.devicePixelRatio);
    this.camera.updateProjectionMatrix();
  }
}

//export const BgGrid = _BgGrid;
