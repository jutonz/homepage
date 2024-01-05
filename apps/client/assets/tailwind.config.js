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
  important: true,
  content: ["./../lib/client_web/**/*.{ex,eex,heex}", "./js/**/*.{jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        primary: "#ac17c6",
      },
    },
  },
  variants: {},
  plugins: [],
};
