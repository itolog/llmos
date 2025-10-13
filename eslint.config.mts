import js from "@eslint/js";
import globals from "globals";
import tsEslint from "typescript-eslint";
import prettier from "eslint-config-prettier";
import prettierPlugin from "eslint-plugin-prettier";
import { defineConfig } from "eslint/config";

export default defineConfig([
  {
    files: ["**/*.{js,mjs,cjs,ts,mts,cts}"],
    languageOptions: {
      globals: {
        ...globals.node,
        Bun: true,
      },
    },
    plugins: {
      js,
      prettier: prettierPlugin,
    },
    extends: ["js/recommended", prettier],
    rules: {
      "prettier/prettier": "error",
    },
  },
  ...tsEslint.configs.recommended,
  {
    rules: {
      "@typescript-eslint/no-explicit-any": "off",
      "@typescript-eslint/no-floating-promises": "warn",
      "@typescript-eslint/no-unsafe-argument": "warn",
      "no-console": "warn",
    },
  },
]);
