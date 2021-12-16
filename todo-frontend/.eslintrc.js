const IGNORE = 0;
const WARNING = 1;
const ERROR = 2;

module.exports = {
  parser: "@typescript-eslint/parser",
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: "module",
    ecmaFeatures: {
      jsx: true,
    },
  },
  plugins: [
    "@typescript-eslint",
    "react",
    "testing-library",
    "jest-dom",
    "jsx-a11y",
  ],
  env: {
    browser: true,
    jest: true,
    node: true,
  },
  ignorePatterns: ["**/generated/*.*"],
  extends: [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:testing-library/react",
    "plugin:jest-dom/recommended",
    "plugin:jsx-a11y/recommended",
    "prettier",
  ],
  settings: {
    react: {
      version: "detect",
    },
  },
  rules: {
    "react/prop-types": "off",
  },
};
