const path = require('path')
const glob = require('glob')
const url = require('url')
const {app, BrowserWindow, Tray, Menu} = require('electron')

const debug = /--debug/.test(process.argv[2])

if (process.mas) app.setName('Center Of Control')

let win, icon, tray
function startWindow () {
    const shouldQuit = app.requestSingleInstanceLock()
    if (!shouldQuit){
        app.quit()
    }else{
        app.on('second-instance', (event, argv, cwd) => {
            if (win) {
                if (win.isMinimized()) win.restore()
                win.focus()
              }
        })
    }

    //loadFunction()

    if (process.platform === 'linux'){
        icon = path.join(__dirname, '/assets/app-icon/png/512.png')    
    }

    win = new BrowserWindow({
        width: 1080,
        minHeight: 800,
        height: 900,
        minHeight: 600,
        title: app.getName(),
        darkTheme: true,
        icon: icon,
        show: false,

        webPreferences: {
            nodeIntegration: true
        }
    })
    win.maximize()

    win.loadURL(url.format({
        pathname: path.join(__dirname, 'index.html'),
        protocol: 'file:',
        slashes: true
    }))

    win.on('closed', ()=>{
        win = null
    })

    win.on('ready-to-show', () => {
        this.show()
    })

    tray = new Tray(path.join(__dirname, 'src/assets/icons/512.png'))
    popupMenu = Menu.buildFromTemplate([
        {
            label: 'Show',
            click: function(){
                win.show()
            }
        },
        {
            label: 'Minimizar',
            click: function(){
                win.hide()
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

    tray.setToolTip('Center Of Control')
    tray.setContextMenu(popupMenu)
}

app.on('ready', startWindow)

app.on('window-all-closed', () => {
if (process.platform !== 'darwin') {
    app.quit()
}
})

app.on('activate', () => {
if (win === null) {
    startWindow()
}

})


function carregaMainProcess() {
    const procs = glob.sync(path.join(__dirname, 'main-process/*.js'))
    procs.forEach((file) => { require(file) })
  }