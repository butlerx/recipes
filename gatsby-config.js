const { name: shortTitle, title, description, author } = require('./package.json');

module.exports = {
  siteMetadata: {
    title,
    shortTitle,
    description,
    url: 'https://recipes.notthe.cloud',
    image: '/images/pancakes.jpg',
    author,
    basePath: '/',
    intro: description,
    menuLinks: [{ name: 'about', slug: '/about' }],
    footerLinks: [
      { name: 'Me', href: 'https://cianbutler.ie' },
      {
        name: 'Gatsby Theme Recipes on Github',
        href: 'https://github.com/mariiinda/gatsby-theme-recipes',
      },
    ],
  },
  plugins: [
    `gatsby-plugin-netlify-cms`,
    {
      resolve: '@marinda/gatsby-theme-recipes',
      options: {
        title,
        shortTitle,
        contentPath: 'recipes',
      },
    },
  ],
};
