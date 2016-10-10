module.exports = {
  root: true,
  parserOptions: {
    ecmaVersion: 6,
    sourceType: 'module'
  },
  extends: [
    'eslint:recommended',
    'plugin:ember-suave/recommended'
  ],
  env: {
    'browser': true
  },
  rules: {
    'no-constant-condition': ['error', { 'checkLoops': false }],
    'operator-linebreak': ['error', 'after'],
    'ember-suave/no-direct-property-access': 'off'
  }
};
