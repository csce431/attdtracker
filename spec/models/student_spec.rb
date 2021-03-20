require 'rails_helper'

RSpec.describe Student, type: :model do
  context 'validation tests' do
    it 'ensures first name presence' do
      student = Student.new(lname: "Last", email: 'email@tamu.edu').save
      expect(student).to eq(false)
    end
    it 'ensures last name presence' do
      student = Student.new(fname: "First", email: 'email@tamu.edu').save
      expect(student).to eq(false)
    end
    it 'ensures email name coorectness' do
      student = Student.new(fname: "Frist", lname: "Last", email: 'email@tamu.edu').save
      expect(student).to eq(true)

      student = Student.new(fname: "Frist", lname: "Last", email: 'email@tau.edu').save
      expect(student).to eq(false)
    end

    it 'ensures email duplicates' do
      student = Student.new(fname: "Frist", lname: "Last", email: 'email@tamu.edu').save
      expect(student).to eq(true)

      student = Student.new(fname: "Frist2", lname: "Last2", email: 'email@tamu.edu').save
      expect(student).to eq(false)
    end
    it 'should save successfully' do
      student = Student.new(lname: "Last", email: 'email@tamu.edu').save
      expect(student).to eq(false)
    end
  end
end
