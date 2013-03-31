$(document).ready(function() {
	$('.action_item_checkbox').change(function() {
		id = this.id;
		$.post('/action_items/toggle_done/'+id, 
			function() {
				task_name = '#task-'+id;
				$(task_name).toggleClass('task_done');
			});
	})
});