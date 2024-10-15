module.exports = {
    preset: 'react-native',
    transform: {
        '^.+\\.(js|jsx|ts)$': 'babel-jest',
    },
    moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx'],
    testPathIgnorePatterns: ["/__tests__/App-test.js"],
    collectCoverage: true,
    collectCoverageFrom: [
        "index.js"
    ],
    coverageDirectory: "coverage",
    coverageReporters: ["text", "lcov"],
};