const {ipcRenderer} = require('electron')
const btnLogradouro = document.getElementById('btn-logradouro')
const btnAddPhone = document.getElementById('evt-add-phone')
const btnAddPhone = document.getElementById('evt-add-phone')


btnLogradouro.addEventListener('click', () => {
  ipcRenderer.send('action-get-info-cep')
})

btnLogradouro.addEventListener('keypress', () => {
  ipcRenderer.send('action-get-info-cep')
})

btnAddPhone.addEventListener('click', () => {

})

ipcRenderer.on('retorn-info-cep', (evt, info) => {
  document.getElementById('logradouro').setAttribute('value', info.logradouro)
  document.getElementById('bairro').setAttribute('value', info.bairro)
  document.getElementById('cep').setAttribute('value', info) //.cep)
  document.getElementById('cidade').setAttribute('value', info.localidade) /* localidade */
  document.getElementById('uf').setAttribute('value', info.uf)
  document.getElementById('comentario').setAttribute('value',  info.complemento)/*complemento */
  document.getElementById('ibge').setAttribute('value', info)
})

