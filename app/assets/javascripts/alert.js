var alert_class = {success: 'alert-success', error: 'alert-danger', alert: 'alert-warning', notice: 'alert-info'}; 
function addAlert(type, message) {
	var $div_alert = $("<div>", {class: "alert alert-dismissible fade in "+alert_class[type]});
	$div_alert.append('<button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>')
	$div_alert.append(message)
	$div_alert.fadeTo(4000, 500).slideUp(500, function(){
		$div_alert.alert('close');
	});	
	$('body').prepend($div_alert);
}