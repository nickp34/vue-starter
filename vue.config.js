const path = require('path');

function resolve(dir) {
  return path.join(__dirname, dir);
}

module.exports = {
  configureWebpack: {
    devServer: {
      proxy: {
        '^/someplace': {
          target: process.env.VUE_APP_SOMEPLACE_SERVER,
          secure: false,
          changeOrigin: true,
          pathRewrite: { '^/someplace': '' },
          logLevel: 'debug',
        },
      },
    },
  },
  chainWebpack: (config) => {
    config.resolve.alias.set('%', resolve('tests'));
  },
};
