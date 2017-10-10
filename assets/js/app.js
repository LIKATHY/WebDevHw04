// Attribute to part of Professor Nathaniel Tuck's class 
// notes and code.
// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

let handlebars = require("handlebars");


$(function() {
  if (!$("#likes-template").length > 0) {
    return;
  }

  let tt = $($("#likes-template")[0]);
  let code = tt.html();
  let tmpl = handlebars.compile(code);

  let dd = $($("#post-likes")[0]);
  let path = dd.data('path');
  let p_id = dd.data('post_id');

  let LikeButton = $($("#like-button")[0]);
  let u_id = LikeButton.data('user-id');
  let arraylikes;
  let data_map;

  function fetch_likes() {
    function got_likes(data) {
      console.log(data);
      arraylikes = data;

      data_map = {}
      for (var i = data.data.length - 1; i >= 0; i--) {
      	let like = data.data[i];
      	data_map[like.user_email] = like
      }


      let deduplicated_data = []
      for (let email in data_map) {
      	deduplicated_data.push(data_map[email])    
      }

      data.data = deduplicated_data

      console.log(data_map, data)

	var this_user_liked = data_map[window.user_email]

	if (!this_user_liked) {
		$('#like-button').html('Like!')
	}
	else {
		$('#like-button').html('Unlike')

	}
      let html = tmpl(data);
      dd.html(html);
    }

    $.ajax({
      url: path,
      data: {post_id: p_id},
      contentType: "application/json",
      dataType: "json",
      method: "GET",
      success: got_likes,
    });
  }

  function add_like() {
    let data = {like: {post_id: p_id, user_id: u_id}};

    $.ajax({
      url: path,
      data: JSON.stringify(data),
      contentType: "application/json",
      dataType: "json",
      method: "POST",
      success: fetch_likes,
    });

  }

  function remove_like() {

  	var u_email_id = data_map[window.user_email].id;

    $.ajax({
      url: path + '/' + u_email_id, 
      contentType: "application/json",
      dataType: "json",
      method: "DELETE",
      success: fetch_likes,
    });

  }


  function button_clicked() {

	var this_user_liked = data_map[window.user_email]

	if (this_user_liked) {
		// unlike here
		remove_like()
		$('#like-button').html('Like!')
	}
	else {
		add_like();
		$('#like-button').html('Unlike')

	}	
  }

  LikeButton.click(button_clicked);

  fetch_likes();
});