const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      colors: {
        'light-blue': '#A3B9C9',
        'beige': '#F8F8F0',
        'brown': '#A1866F',
        'dark-gray': '#404040',
        'light-gray': '#D9D9D9',
        'yellow': '#FFFACD',
        'matcha': '#6B8C42',
        'cocoa-brown': '#A1866F'
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ]
}
