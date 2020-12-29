module.exports = {
  purge: [
    "./../lib/client_web/templates/**/*.eex",
    "./../lib/client_web/controllers/**/*_live.ex",
    "./js/**/*.tsx"
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
