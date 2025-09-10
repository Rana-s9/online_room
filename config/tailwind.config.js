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
        'blue' : '#8DA8BB',
        'bright-blue' : '#7F9BB3',
        'gray-blue': '#8FA6B8',
        'beige': '#F8F8F0',
        'dark-beige': '#E2D9C8',
        'brown': '#A1866F',
        'dark-gray': '#404040',
        'light-gray': '#D9D9D9',
        'gray': '#757575',
        'yellow': '#FFFACD',
        'matcha': '#005060',
        'cocoa-brown': '#A1866F',
        'pink-red': '#F37167',
        'matcha-green': '#6B8C42'
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        eng: ['"Playfair Display"', ...defaultTheme.fontFamily.sans],
        natural: ['"Noto Serif JP"', '"Yu Mincho"', '"Hiragino Mincho ProN"', 'serif'],
      },
      screens: {
        'ipadpro': '1024px',  // iPad Pro向けカスタムブレークポイント
        'lg': '1280px',       // lg を1280pxにリセット（デフォルトは1024px）
      },
    },
  },
  plugins: [
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ]
}
