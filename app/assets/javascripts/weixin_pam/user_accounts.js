// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
  if($('body[data-page="user_accounts_index"]')[0]) {
    console.log('user_accounts_index')
    $(document).on('ajax:success', function(data, status, xhr){
      console.log(status)
      switch(status.action){
        case 'sync_users':
          if(status.success){
            Turbolinks.enableTransitionCache(true);
            Turbolinks.visit(location.href);
            Turbolinks.enableTransitionCache(false);
          }
          else
            appendFlashMessage('danger', '同步失败，失败原因：' + status.msg);
          break;
      }
    }).on('ajax:error', function(xhr, status, error){
      appendFlashMessage('danger', '请求失败');
    });
  }
})