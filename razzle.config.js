module.exports = {
  modify: (config, { target, dev }, webpack) => {
    // do something to config
    const appConfig = config // stay immutable here

    if (target === 'node' && !dev) {
      appConfig.externals = []
    }

    return appConfig
  },
}
