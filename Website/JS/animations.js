let currentpage;

document.getElementById('Crowdsale').style.display = "none";
document.getElementById('DAO').style.display = "none";
document.getElementById('Staking').style.display = "none";


if(window.location.href == "https://classicdao.one/dscrowdsale"){
    document.getElementById('menuone').className = "Mactive"; 
}
if(window.location.href == "https://classicdao.one/dsgovernance"){
    document.getElementById('menutwo').className = "Mactive"; 
}
if(window.location.href == "https://classicdao.one/dsstaking"){
    document.getElementById('menutre').className = "Mactive"; 
}

function setActive(id) {
    document.getElementById('menuone').className = "Minactive"; 
    document.getElementById('menutwo').className = "Minactive"; 
    document.getElementById('menutre').className = "Minactive"; 

    document.getElementById(id).className = "Mactive"; 
}

function removeOverlay(){
    document.getElementById('overlay').style.display = "none";
}
