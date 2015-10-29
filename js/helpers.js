/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

var ChartManager = function (){
	
};

var RestCallManager = function( callback , http) {
	
};

RestCallManager.prototype.post = function( callback , http , data , action ){
    console.log("post data");
    console.log(data);
	$('html').css('cursor' , 'progress');
	http.post('server/WebService.php', {
		"action" : action,
		"data" : data
	}).
	success(function(data, status) {
		callback(data , status , true);
		$('html').css('cursor' , 'default');
	})
	.
	error(function(data, status) {
		callback(data , status , false);
		$('html').css('cursor' , 'default');
	});
}



var AlertManager = function (){

};

AlertManager.prototype.successAlert = function(){
	new PNotify({
		title: 'שמירת נתונים',
		text: 'שמירת הנתונים הסתיימה בהצלחה',
		type: 'success'
	});
}

AlertManager.prototype.failAlert = function(){
	new PNotify({
		title: 'שמירת נתונים',
		text: 'שמירת הנתונים נכשלה',
		type: 'danger'
	});
}

ExportManager = function (){


	this.csvArray = [
        {
            "creationDate": 'תאריך מילואי הטופס'
        },
		{
			"userId": 'ת.ז.'
		},
		{
			"userFullName" : "שם + שם משפחה"
		},
		{
			"userEmail" : "כתובת אי מייל"
		},
		{
			"userPhone" : "טלפון"
		},
		{
			"userBornYear" : "שנת לידה"
		},
		{
			"gender" : "מין"
		},
		{
			"unit" : "יחידה"
		},
		{
			"userJoiningArmyDate" : "תאריך גיוס"
		},
		{
			"userReleasingArmyDate" : "תאריך שחרור"
		},
		{
			"userPersonalNumber" : "מספר אישי"
		},
		{
			"userPtorReason" : "סיבת הפטור"
		},
		{
			"miluimQuestion" : "האם שירתת במילואים בשנה האחרונה ?"
		},
		{
			"numberOfMiluimDays" : "מספר ימי מילואים"
		},
		{
			"abroadQuestion" : 'האם במהלך השנה האחרונה שהית בחו"ל?'
		},
		{
			"numberOfTimesAbroad" : "כמה פעמים ?"
		},
		{
			"userLocationOnStudies" : "יישוב בזמן הלימודים"
		},
		{
			"userLocationAddressOnStudies" : "כתובת בזמן בלימודים"
		},
		{
			"userLocationZipOnStudies" : "מיקוד בזמן הלימודים"
		},
		{
			"userLocationPhoneOnStudies" : "טלפון בזמן הלימודים"
		},
		{
			"studingDetails_location_question" : "בשנת הלימודים הנוכחית הנך גר ב"
		},
		{
			"carQuestion" : "האם בבעלותך או ברשותך* או בבעלות או ברשות בן/ת זוגך** רכב?"
		},
		{
			"carQuestionModel" : "סוג הרכב"
		},
		{
			"carQuestionValue" : "ערך הרכב"
		},
		{
			"carQuestion_extraCar" : "האם בבעלותך או ברשותך* או בבעלות או ברשות בן/ת זוגך** רכב?"
		},
		{
			"extraCarModel" : "סוג הרכב"
		},
		{
			"extraCarModelYear" : "שנת ייצור"
		},
		{
			"extraCarModelNumber" : "מס' רישוי"
		},
		{
			"extraCarValue" : "ערך הרכב"
		},
		{
			"hasJobQuestion" : "האם בשנת הלימודים הנוכחית הנך עובד/ת?"
		},
		{
			"jobLocation" : "מקום העבודה"
		},
		{
			"jobAddress" : "כתובת"
		},
		{
			"jobPhone" : "טלפון"
		},
		{
			"jobSalary" : "מהו השכר החודשי"
		},
		{
			"sideJobLocation" : "מקום העבודה (משרה חלקית)"
		},
		{
			"sideJobSalary" : "הערכת שכר (משרה חלקית)"
		},
		{
			"jobDetails_salary_depths" : "האם הנך משלם החזר חובות, לא כולל משכנתא ?"
		},
		{
			"depthsAmount" : "על סך"
		},
		{
			"depthsPurpose" : "לאיזו מטרה ?"
		},
		{
			"depthsDuration" : "הזמן שנותר לסיום"
		},
		{
			"jobDetails_salary_fundingQuestion" : "האם הנך מקבל מימון כלשהו ?"
		},
		{
			"jobDetails_salary_fundingAmount" : "על סך"
		},
		{
			"jobDetails_salary_fundingSourceQuestion" : "ציין את מקור המימון"
		},
		{
			"marriedStatus" : "סטטוס משפחתי"
		},
		{
			"partnerForLifeId" : "ת.ז. של בן/ת הזוג (כולל ספרת ביקורת)"
		},
		{
			"partnerForLifeName" : "שם"
		},
		{
			"partnerForLifeJob" : "סוג העבודה של הבן\ת זוג"
		}
	];
}

ExportManager.prototype.getHeaders = function(){
	var headers = [];
	this.csvArray.forEach(function(header){
		headers.push(header[Object.keys(header)[0]]);
        console.log(Object.keys(header)[0]);
	});

	return headers;
}

ExportManager.prototype.getCsvContents = function(data){
	var csvArrayList = this.csvArray;
	var csvRowArray = [];
	data.forEach(function(row){
		var rowObject = {};
		csvArrayList.forEach(function(csvObject){
				var index = Object.keys(csvObject)[0];
			    rowObject[index] = row[index];
		});
		csvRowArray.push(rowObject);

	});

	return csvRowArray;
}

ExportManager.prototype.exportToCsv = function(){
	var exportHeraders = [
			{
				"userId": 'ת.ז.'
			},
			{
				"userFullName" : "שם + שם משפחה"
			}
		]

	return exportHeraders;

}



