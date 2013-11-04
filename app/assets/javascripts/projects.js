$(document).ready(function() {
	$('.project_goal_checkbox').change(function() {
		goal_key = this.id;
		project_key = $('#'+goal_key).data('project');
		$.post('/projects/'+project_key+'/serve_goal_toggle/'+goal_key, 
			function() {
//				task_name = '#goal-'+id;
//				$(task_name).toggleClass('task_done');
			});
	});
})