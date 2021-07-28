module.exports = {
  purge: [
    "./../lib/client_web/templates/**/*.eex",
    "./../lib/client_web/controllers/**/*_live.ex",
    "./../lib/client_web/live/**/.ex",
    "./js/**/*.tsx",
  ],
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
