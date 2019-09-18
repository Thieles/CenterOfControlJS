'use struct'
const settings = require('electron-settings')

document.getElementById("menu-left").addEventListener('click', (evt) => {
  if(event.target.dataset.section){
    ativaFuncao(evt)
  } else if (event.target.dataset.modal){
    funcaoAtivaPadrao()
  } else if (event.target.classList.contains('.btn-navigation.active')){
      ocultAllModel()
  }
})


function funcaoAtivaPadrao() {
  document.getElementById('home').click()
}

function ativaFuncao(evt) {
  removeFuncaoAtiva()
  evt.target.classList.add('active')

  let funcaoID = `${event.target.dataset.section}-functions`
  document.getElementById(funcaoID).classList.add('show-view')
  
  let buttonID = event.target.getAttribute('id')
  settings.set('activeSectionButtonId', buttonID)
}
function removeFuncaoAtiva() {
  const sections = document.querySelectorAll('.secjs.show-view')
    Array.prototype.forEach.call(sections, (section) => {
        section.classList.remove('show-view')
    })
    const buttons = document.querySelectorAll('.btn-navigation.active')
    Array.prototype.forEach.call(buttons, (button) => {
        button.classList.remove('active')
    })
}
function containerPadrao() {
  //document.querySelector('.navjs').classList.add('visivel')
  document.querySelector('.window-content-js').classList.add('show-view')
}

function ocultAllModel() {
  const models = document.querySelectorAll('modal.show-view')
  Array.prototype.forEach.call(models, (model) => {
      model.classList.remove('show-view')
  })
  containerPadrao()
}

function home() {
  document.querySelector('#home-functions').classList.add('show-view')
}
const sectionId = settings.get('activeSectionButtonId')
if (sectionId) {
  containerPadrao()
  const section = document.getElementById(sectionId)
  if (section) section.click()
} else {
  funcaoAtivaPadrao()
  home()
}