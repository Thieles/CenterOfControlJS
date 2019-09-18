const path = require('path')
const glob = require('glob')
const url = require('url')
const {app, BrowserWindow, Tray, Menu} = require('electron')

if (process.mas) app.setName('Center Of Control')

let mainWindow, tray

function createWindow() {
  const shouldQuit = makeSingleInstance()
  if (shouldQuit) return app.quit()

  mainWindow = new BrowserWindow({
    width: 1080,
    minHeight: 800,
    height: 900,
    minHeight: 600,
    title: app.getName(),
    darkTheme: true,
    show: false,
    frame: false,
    webPreferences: {
      nodeIntegrationInWorker: true
    }
  })
  mainWindow.maximize()

  if (process.platform === 'linux') {
    mainWindow.icon = path.join(__dirname, 'src/assets/icons/512.png')
  }
  mainWindow.loadURL(`file://${__dirname}/index.html`)

  mainWindow.on('closed', () => {
    mainWindow = null
  })

  tray = new Tray(path.join(__dirname, 'src/assets/icons/512.png'))
    popupMenu = Menu.buildFromTemplate([
        {
            label: 'Show',
            click: function(){
              mainWindow.show()
            }
        },
        {
            label: 'Minimizar',
            click: function(){
              mainWindow.hide()
            }
        },
        {
            label: 'Sair',
            click: function(){
                app.isQuiting = true
                app.quit()
            }
        }
    ])

    tray.setToolTip(app.getName())
    tray.setContextMenu(popupMenu)

  //carregaMainProcess()
}

app.on('ready', createWindow)

app.on('window-all-cloded', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  if (mainWindow === null) {
    createWindow()
  }
})

function makeSingleInstance () {
  if (process.mas) return false

  return app.makeSingleInstance(() => {
    if (mainWindow) {
      if (mainWindow.isMinimized()) mainWindow.restore()
      mainWindow.focus()
    }
  })
}

function carregaMainProcess() {
  const procs = glob.sync(path.join(__dirname, 'main-process/*.js'))
  procs.forEach((file) => { require(file) })
}