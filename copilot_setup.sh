#!/bin/bash

# Official GitHub Copilot Setup Script for Neovim
echo "🤖 Official GitHub Copilot Setup for Neovim"
echo "=========================================="

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Copilot requires Node.js v18+"
    exit 1
fi

NODE_VERSION=$(node --version)
echo "✅ Node.js version: $NODE_VERSION"

# Start Neovim and setup Copilot
echo ""
echo "🔐 Starting Copilot setup..."
echo "📝 This will open Neovim and run :Copilot setup"
echo "   Follow the instructions to authenticate with GitHub"
echo ""
echo "Press Enter to continue..."
read

nvim -c "Copilot setup" -c "echo 'After setup, type :q to quit'"

echo ""
echo "🧪 Testing Copilot integration..."
echo "📝 This will create a test file to check if Copilot suggestions work"

# Create a test JavaScript file
cat > test_copilot.js << EOF
// Test file for GitHub Copilot
// Try typing the following comments and see if you get suggestions:

// Function to calculate the factorial of a number
function factorial(n) {
    // TODO: implement factorial calculation
}

// Function to check if a number is prime
function isPrime(num) {
    // TODO: implement prime number check
}

// Function to sort an array of numbers
function sortArray(arr) {
    // TODO: implement array sorting
}
EOF

echo "✅ Created test_copilot.js"
echo ""
echo "🚀 Opening test file in Neovim..."
echo "📝 Try typing after the TODO comments to see Copilot suggestions"
echo "💡 Press <Tab> to accept suggestions, <Alt+]> for next, <Alt+[> for previous"
echo "   Type :q to quit when done testing"

nvim test_copilot.js

# Clean up
echo ""
echo "🧹 Cleaning up test file..."
rm -f test_copilot.js
echo "✅ Test file removed"

echo ""
echo "🎉 Official Copilot setup complete!"
echo "💡 Tips:"
echo "   - Copilot suggestions appear inline as gray text"
echo "   - Press <Tab> to accept suggestions"
echo "   - Press <Alt+]> for next suggestion, <Alt+[> for previous"
echo "   - Use :Copilot panel to see multiple suggestions"
echo "   - Write descriptive comments to get better suggestions"
echo "   - Copilot works best with common programming patterns"
