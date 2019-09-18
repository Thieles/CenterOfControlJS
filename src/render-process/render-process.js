function openNav() {
  document.getElementById("side").style.width = "250px";
  document.querySelector("main").style.marginLeft = "250px";
}

/* Set the width of the side navigation to 0 and the left margin of the page content to 0 */
function closeNav() {
  document.getElementById("side").style.width = "0";
  document.querySelector("main").style.marginLeft = "0";
}