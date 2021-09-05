const getEnv = () => {
  switch (process.env.MIX_ENV) {
    case "prod":
      return "prod";
    default:
      return "dev";
  }
};

const env = getEnv();
const isProd = env === "prod";

module.exports = {
  purge: {
    enabled: isProd,
    content: [
      "./../lib/client_web/templates/**/*.eex",
      "./../lib/client_web/controllers/**/*_live.ex",
      "./../lib/client_web/live/**/*.ex",
      "./js/**/*.tsx",
    ],
  },
  theme: {
    extend: {
      colors: {
        primary: "#ac17c6",
      },
    },
  },
  variants: {},
  plugins: [],
  future: {
    removeDeprecatedGapUtilities: true,
    purgeLayersByDefault: true,
  },
};
