let ipts = document.querySelectorAll('link[rel="import"]')
Array.prototype.forEach.call(ipts, (imp)=>{
    let tsk = imp.import.querySelector('.tsk-element')
    let copia = document.importNode(tsk.content, true)
    if (imp.href.match('about.html')) {
        document.querySelector('body').appendChild(copia)
    } else {
        document.querySelector('.window').appendChild(copia)
    }
})