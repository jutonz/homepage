module.exports = {
  purge: [
    "./../lib/client_web/templates/**/*.eex"
  ],
  theme: {},
  variants: {},
  plugins: [],
  future: {
    removeDeprecatedGapUtilities: true,
    purgeLayersByDefault: true,
  }
}
