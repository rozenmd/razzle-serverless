module.exports = {
  modify: (config, { target, dev }, webpack) => {
    // do something to config
    const appConfig = config // stay immutable here

    if (target === 'node' && !dev) {
      appConfig.externals = []
      appConfig.output.publicPath = `${process.env.PUBLIC_PATH}`
    }

    return appConfig
  },
}
