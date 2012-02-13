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
    //    console.log(btn, user_id);
    if (user_id == null){
        return false;
    }

    $.post( 'send_to_buyer/' + user_id )
    .complete(function() {
        alert("Jewels have been sent");
    });

}

function submit_by_buyer(btn, user_id){
    //    console.log(btn, user_id);
    if (user_id == null){
        return false;
    }

    var selJewels = $('.approved-jewel .jewel-item');
    var selJewelItems = $.map( selJewels, function(val, i) {
        var jewel = {
            id: $(val).find('input[name=jewel_id]').val(),
            approved: ($(val).find('input[name=approved_indicator]').attr("checked") != null)
        };
        return jewel;
    });

    var url = 'submit_by_buyer/' + user_id,
    params = {
        'jewels': JSON.stringify(selJewelItems)
    };

    $.post( url, params )
    .complete(function() {
        alert("Jewels are submitted");
    });
}

function send_comment(btn, user_id, jewel_id){
    //    console.log(btn, user_id, jewel_id);
    if (user_id == null || jewel_id == null){
        return false;
    }

    var url = 'send_comment/' + jewel_id,
    textField = $('.new-comment-' + user_id + '-' +  jewel_id + ' input')[0],
    comment = $(textField).val();
    
    $(textField).val('');

    var params = { 
        user_id: user_id,
        comment: comment
    }

    $.post( url, params )
    .success(function(data) {
        if (data.success){
            var container = $('.jewel-comments-list-' + user_id + '-' +  jewel_id)[0];
            $(container).append(data.data);
            $(container).find('.comment').last().show();

            var checkbox = $(btn).parents('.jewel-item').find("[type=checkbox]");
            $(checkbox).removeAttr("checked");
        } else { 
            alert( data.msg || "Server return some error");
        }
    })
    .error(function(data) {
        alert("We are sorry, but something went wrong on server.");
    })
}

function showCart(btn){
    var cartItems = $('.cart-item');
    var isPressed =  $(btn).data('isPressed');
    if (isPressed){
        $(cartItems).hide();
    } else {
        $(cartItems).show();
    }
    $(btn).data({
        isPressed: !isPressed
    })
}

function expandComments(btn, jewel_id, user_id){
    if (user_id == null || jewel_id == null){
        return false;
    }
    
    var comments = $('.jewel-comments-list-' + user_id + '-' +  jewel_id + ' .comment');
    var isPressed =  $(btn).data('isPressed');
    if (isPressed){
        $(btn).text('More Comments');
        $(comments).hide();
        $(comments).last().show();
    } else {
        $(btn).text('Less Comments');
        $(comments).show();
    }
    $(btn).data({
        isPressed: !isPressed
    })

}

$(function() {
    $( ".avail-jewel, .approved-jewel" ).sortable({
        connectWith: ".connectedSortable"
    }).disableSelection();
    
    var comment_lists = $('.jewel-comments-list');
    $(comment_lists).each(function(index, list) {
        var comments = $(list).find('.comment');
        $(comments).last().show();
    });
});