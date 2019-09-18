'use struct'
const ipcMain = require('electron')
const execFileSync  = require('child_process');

ipcMain.on('action-get-info-cep', (evt) => {
  evd = execFileSync("jruby", ['./ruby/PessoaFisica.rb'])
  evt.sender.send('retorn-info-cep', evd)
})