'use strict'

import { app, BrowserWindow, ipcMain, Tray, Menu } from 'electron'
const path = require('path')

const electron = require('electron') // eslint-disable-line

/**
 * Set `__static` path to static files in production
 * https://simulatedgreg.gitbooks.io/electron-vue/content/en/using-static-assets.html
 */
if (process.env.NODE_ENV !== 'development') {
  global.__static = require('path').join(__dirname, '/static').replace(/\\/g, '\\\\')
}

let mainWindow;
const winURL = process.env.NODE_ENV === 'development'
  ? `http://localhost:9080`
  : `file://${__dirname}/index.html`;

  function createWindow () { 
    /**
     * Initial window options
     */
    mainWindow = new BrowserWindow({
      height: 563,
      useContentSize: true,
      width: 1000,
      minWidth: 800,
      webPreferences: {webSecurity: false}, // 可实现跨域
      frame: false // 去掉边框
    })
    // 系统托盘右键菜单
    var trayMenuTemplate = [
      {
        label: '设置',
        click: function () {} // 打开相应页面
      },
      {
        label: '意见反馈',
        click: function () {}
      },
      {
        label: '帮助',
        click: function () {}
      },
      {
        label: '关于圣诞',
        click: function () {}
      },
      {
        label: '退出圣诞',
        click: function () {
          // ipc.send('close-main-window');
          app.quit()
        }
      }
    ]
  
    const url = path.join(__dirname, '../../build/icons/icon.ico')
    // 系统托盘图标
    let tray = new Tray(url)
    // 鼠标放到系统托盘图标上时的tips;
    tray.setToolTip('圣诞音乐')
    // 图标的上下文菜单
    const contextMenu = Menu.buildFromTemplate(trayMenuTemplate)
    // 设置此图标的上下文菜单
    tray.setContextMenu(contextMenu)
    // 双击图片显示窗口
    tray.on('double-click', () => {
      mainWindow.show()
      mainWindow.focus()
    })
  
    mainWindow.loadURL(winURL)
    mainWindow.on('closed', () => {
      mainWindow = null
    })
  }
  app.on('ready', createWindow)
  
  // 退出
  ipcMain.on('window-all-closed', () => {
    app.quit()
  })
  
  // 隐藏窗口
  ipcMain.on('hide-main-window', function () {
    mainWindow.hide()
  })
  
  // 小化
  ipcMain.on('hide-window', () => {
    mainWindow.minimize()
  })
  // 最大化
  ipcMain.on('show-window', () => {
    mainWindow.maximize()
  })
  // 还原
  ipcMain.on('orignal-window', () => {
    mainWindow.unmaximize()
  })
  
  app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
      app.quit()
    }
  })
  
  app.on('activate', () => {
    if (mainWindow === null) {
      createWindow()
    }
  })
  
  /**
   * Auto Updater
   *
   * Uncomment the following code below and install `electron-updater` to
   * support auto updating. Code Signing with a valid certificate is required.
   * https://simulatedgreg.gitbooks.io/electron-vue/content/en/using-electron-builder.html#auto-updating
   */
  
  /*
  import { autoUpdater } from 'electron-updater'
  
  autoUpdater.on('update-downloaded', () => {
    autoUpdater.quitAndInstall()
  })
  
  app.on('ready', () => {
    if (process.env.NODE_ENV === 'production') autoUpdater.checkForUpdates()
  })
   */
  