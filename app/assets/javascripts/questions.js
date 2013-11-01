$(document).ready(function() {
	$('#reveal_questions').click(function() {
		$('#questions_hidden').removeClass('hidden');
		$('#questions_hidden').show();
	})
});

cp ../rb-life_advisor/app/assets/javascripts/action_items.js app/assets/javascripts/
cp ../rb-life_advisor/app/assets/javascripts/questions.js app/assets/javascripts/
cp ../rb-life_advisor/app/assets/stylesheets/application.css app/assets/stylesheets/