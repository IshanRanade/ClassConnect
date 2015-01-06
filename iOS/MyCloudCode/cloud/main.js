// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:

//Creates the online database of universities, departments, and classes based on a provided JSON file
Parse.Cloud.define("createClassesDatabase", function(request, response) {
	var data = JSON.parse(request.params.data);
	for(var i = 0; i < data.universities.length; i++) {
		//Create a UniversityObject
		var UniversityObject = Parse.Object.extend("University");
		var universityObject = new UniversityObject();

		//Set its attributes
		var universityName = data.universities[i]["universityName"];
		universityObject.set("universityName", universityName);

		//Save it
		universityObject.save();
		for(var j = 0; j < data.universities[i].departments.length; j++) {
			//Create a department object
			var DepartmentObject = Parse.Object.extend("Department");
			var departmentObject = new DepartmentObject();

			//Save its attributes
			var departmentName = data.universities[i].departments[j]["departmentName"];
			departmentObject.set("departmentName", departmentName);
			departmentObject.set("parentUniversity", universityName);

			//Save it
			departmentObject.save();

			//Create an array of all courses
			var coursesArray = new Array();
			for(var k = 0; k < data.universities[i].departments[j].courses.length; k++) {
				var courseName = data.universities[i].departments[j].courses[k]["courseName"];
				coursesArray.push(courseName);
				/*//Create the course object
				var CourseObject = Parse.Object.extend("Course");
				var courseObject = new CourseObject();

				//Save its attributes
				var courseName = data.universities[i].departments[j].courses[k]["courseName"];
				courseObject.set("courseName", courseName);
				courseObject.set("parentDepartment", departmentName);
				courseObject.set("parentUniversity", universityName);

				//Save it
				courseObject.save();*/
			}
			departmentObject.set("courses", coursesArray);
			departmentObject.save();
		}
	}
});

//Return an array of the departments for a provided UniversityObject
//Takes a parameter of universityName
Parse.Cloud.define("hello", function(request, response) {
  response.success(JSON.stringify("Hello World"));
});

Parse.Cloud.define("returnDepartmentsForUniversity", function(request, response) {
	//Create the query
	var Department = Parse.Object.extend("Department");
	var query = new Parse.Query(Department);

	//Set the bounds of the query
	query.equalTo("parentUniversity", request.params["university"]);
	query.limit(500);

	//Do the query
	query.find({
		success: function(results) {
			response.success(JSON.stringify(results));
		}
	});
});

Parse.Cloud.define("returnAllUniversities", function(request, response) {
	//Create the query
	var University = Parse.Object.extend("University");
	var query = new Parse.Query(University);

	//Do the query
	query.find({
		success: function(results) {
			response.success(JSON.stringify(results));
		}
	});
});

Parse.Cloud.define("returnSpecificDepartment", function(request, response) {
	//Create the query
	var Department = Parse.Object.extend("Department");
	var query = new Parse.Query(Department);

	//Set the bounds of the query
	query.equalTo("parentUniversity", request.params["university"]);
	query.equalTo("departmentName", request.params["department"]);

	//Do the query
	query.find({
		success: function(results) {
			response.success(JSON.stringify(results));
		}
	});
});








