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
  plugins: {
    "tailwindcss/nesting": {},
    tailwindcss: {},
    autoprefixer: {},
    ...(isProd ? { cssnano: {} } : {}),
  },
};
