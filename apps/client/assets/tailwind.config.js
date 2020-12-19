module.exports = {
  purge: ["./../lib/client_web/templates/**/*.eex", "./js/**/*.tsx"],
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
