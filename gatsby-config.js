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
    menuLinks: [{ name: 'home', slug: '/' }],
    footerLinks: [
      {
        name: 'Gatsby Theme Recipes on Github',
        href: 'https://github.com/mariiinda/gatsby-theme-recipes',
      },
    ],
  },
  plugins: [
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
