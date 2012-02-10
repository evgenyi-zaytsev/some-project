// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

function sentToBuyerBtnClick(btn, user_id){
    console.log(btn, user_id);
    if (user_id == null){
        return false;
    }

    $.post(
        'send_to_buyer/' + user_id
    )
        .complete(function() {
            alert("Jewels have been sent"); 
        });
    
}

function submit_by_buyer(btn, user_id){
    console.log(btn, user_id);
    if (user_id == null){
        return false;
    }
    
    var selectedJewels = [];
    
    console.log($('.approved-jewel input'));
    
    var url = 'submit_by_buyer/' + user_id,
        params = { 'jewels[]': selectedJewels };
    
    $.post(
        url, params
    )
        .complete(function() {
            alert("Jewels are submitted"); 
        });
}

$(function() {
    $( ".avail-jewel, .approved-jewel" ).sortable({
        connectWith: ".connectedSortable"
    }).disableSelection();
});