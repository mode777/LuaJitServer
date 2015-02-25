local firstnames = {"Anderson","Juliet","Keira","Noel","Michaela","Delana","Aline","Donella","Arvilla","Susannah","Carmelo","Delaine","Maxine","Julianna","Carina","Celia","Rivka","Donnetta","Florentino","Willetta"}
local surnames = {"Aaron","Abbott","Abel","Abell","Abernathy","Abney","Abraham","Abrams","Abreu","Acevedo","Acker","Ackerman","Acosta","Acuna","Adair","Adam","Adame","Adams","Adamson","Adcock","Addison","Adkins","Adler","Agee","Agnew","Aguiar","Aguilar","Aguilera","Aguirre","Ahern","Ahmed","Ahrens","Aiello","Aiken","Ainsworth","Akers","Akin","Akins","Alaniz","Alarcon","Alba","Albers","Albert","Albertson","Albrecht","Albright","Alcala","Alcorn","Alderman","Aldrich","Aldridge","Aleman","Alexander" }
local classnames = {"5a","5b","5c","5d","6a","6b","6c","6d","7a","7b","7c","7d","8a","8b","8c","8d","9a","9b","9c","9d"}
local r = math.random
local data = require "dataTable"

local students = {}
local teachers = {}
local subjects = { {name="German"},{name="Math"},{name="English"},{name="Science"},{name="Geopgraphy"},{name="History"},{name="Arts"} }
local classes = {}

local function createStudent()
    return {
        firstName =  firstnames[r(#firstnames)],
        lastName = surnames[r(#surnames)],
        teachers = {},
        class = nil
    }
end

local function createTeacher()
    return {
        firstName =  firstnames[r(#firstnames)],
        lastName = surnames[r(#surnames)],
        classes = {},
        subjects = {}
    }
end

local function createClass()
    return {
        name = classnames[#classes+1],
        classTeacher = nil,
        students = {}
    }
end

return function(root)
    for i=1,500 do
        students[i] = data.wrap(createStudent());
    end
    for i=1,50 do
        teachers[i] = data.wrap(createTeacher());
    end
    for i=1,20 do
        classes[i] = data.wrap(createClass());
    end
    for _,student in ipairs(students) do
        for i=1, 10 do
            table.insert(student.teachers,teachers[r(#teachers)])
        end
        student.class = classes[r(#classes)]
        table.insert(student.class.students,student)
    end
    for _,teacher in ipairs(teachers) do
        for i=1, 2 do
            table.insert(teacher.subjects,subjects[r(#subjects)])
        end
        for i=1, 10 do
            table.insert(teacher.classes,classes[r(#classes)])
        end
        classes[r(#classes)].classTeacher = teacher
    end
    for i=1,500 do
        students[i].save()
    end
    for i=1,50 do
        teachers[i].save()
    end
    for i=1,20 do
        classes[i].save()
    end
    return { students=students, teachers=teachers, classes=classes }
end