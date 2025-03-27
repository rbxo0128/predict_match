/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
      "./src/main/webapp/**/*.jsp",  // ✅ 모든 JSP 파일 포함
      "./src/main/webapp/**/*.html", // (선택) HTML 파일도 포함
      "./src/main/webapp/**/*.js",   // (선택) JavaScript 파일도 포함
    ],
  theme: {
    extend: {
      colors: {
        'lck-primary': '#1A202C',
        'lck-secondary': '#2D3748',
        'lck-accent': '#4A5568'
      },
      fontFamily: {
        'sans': ['Inter', 'system-ui', 'sans-serif']
      }
    },
  },
  plugins: [],
}