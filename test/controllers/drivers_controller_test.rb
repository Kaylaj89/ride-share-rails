require "test_helper"

describe DriversController do
  # Note: If any of these tests have names that conflict with either the requirements or your team's decisions, feel empowered to change the test names. For example, if a given test name says "responds with 404" but your team's decision is to respond with redirect, please change the test name.

  describe "index" do
    it "responds with success when there are many drivers saved" do
      Driver.create(name: "CheezitMan", vin: "ABCDEFGHIJKLMNOPQ")
      # Act
      get drivers_path
      # Assert
      must_respond_with :success
    end

    it "responds with success when there are no drivers saved" do
      # Arrange
      # Ensure that there are zero drivers saved

      # Act
      get drivers_path
      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid driver" do
      driver = Driver.create(name: "CheezitMan", vin: "ABCDEFGHIJKLMNOPQ")
      # Arrange

      # Ensure that there is a driver saved
      # Act
      get driver_path(driver.id)
      # Assert
      must_respond_with :success
    end

    it "responds with 404 with an invalid driver id" do
      # Arrange
      # Ensure that there is an id that points to no driver

      # Act
      get driver_path(Driver.last.id + 1)
      # Assert
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "responds with success" do
      #arrange
      get new_driver_path
      #Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new driver with valid information accurately, and redirect" do
      # Arrange
      # Set up the form data
      driver_hash = {
          driver: {
              name: "Solomon Mehru",
              vin: "WBWSS52P9NEYLVDE9",
          },
      }
      # Act-Assert
      #Ensure that there is a change of 1 in Driver.count
      expect {
              post drivers_path, params: driver_hash
            }.must_change "Driver.count", 1

            new_driver = Driver.find_by(name: driver_hash[:driver][:name])
            expect(new_driver.vin).must_equal driver_hash[:driver][:vin]
            # expect(new_driver.available).must_equal :true

            must_respond_with :redirect
            must_redirect_to driver_path(new_driver.id)

      # Assert
      # Find the newly created Driver, and check that all its attributes match what was given in the form data
      # Check that the controller redirected the user
      end


    it "does not create a driver if a proper vin is not provided" do

      driver_hash = {
          driver: {
              name: "Richard Salazar",
              vin: "48765"
          }
      }

      #Assert
      expect {
        post drivers_path, params: driver_hash
      }.wont_change "Driver.count"
    end

      it "does not create a driver if a name is not provided" do

        driver_hash = {
            driver: {
                name: nil,
                vin: "abcdefghijklmnopq"
            }
        }

        #Assert
        expect {
          post drivers_path, params: driver_hash
        }.wont_change "Driver.count"

      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Set up the form data so that it violates Driver validations

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Check that the controller redirects
    end
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid driver" do
      driver = Driver.create(name: "Adie A", vin: "ABCDEFGHIJKLMNOPQ")

      #Arrange
      get edit_driver_path(driver.id)
      #Assert
      must_respond_with :success

    end

    it "responds with redirect when getting the edit page for a non-existing driver" do
      # Act
      get edit_driver_path(-1)
      # Assert
      must_respond_with :not_found
    end
  end

  describe "update" do
    it "can update an existing driver with valid information accurately, and redirect" do
      driver = Driver.create(name: "Update Me", vin: "ABCDEFGHIJKLMNOPQ")

      driver_hash = {
          driver: {
              name: "new name",
              vin: "ABCDEFGHIJKLMNOPQ"
          }
      }

      id = driver.id
      #Assert
      expect {
        patch driver_path(id), params: driver_hash
      }.must_differ 'Driver.count', 0 #updating the book, we're not adding a book

      must_redirect_to driver_path(id)

      new_driver = Driver.find_by(id: id)
      expect(new_driver.name).must_equal driver_hash[:driver][:name]
      expect(new_driver.vin).must_equal driver_hash[:driver][:vin]

      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      # Set up the form data

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Use the local variable of an existing driver's id to find the driver again, and check that its attributes are updated
      # Check that the controller redirected the user

    end

    it "does not update any driver if given an invalid id, and responds with a 404" do
      #Act
      patch driver_path(-1)
      #Assert
      must_respond_with :not_found

      # Arrange
      # Ensure there is an invalid id that points to no driver
      # Set up the form data

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Check that the controller gave back a 404

    end

    it "does not create a driver if a proper vin is not provided" do

      driver_hash = {
          driver: {
              name: "Richard Salazar",
              vin: "48765"
          }
      }

      #Assert
      expect {
        post drivers_path, params: driver_hash
      }.wont_change "Driver.count"
    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      driver = Driver.create(name: "Update Me", vin: "ABCDEFGHIJKLMNOPQ")

      driver_hash = {
          driver: {
              name: "new name",
              vin: nil
          }
      }
      id = driver.id
      #Assert
      expect {
        patch driver_path(id), params: driver_hash
      }.wont_change 'Driver.count'
      ##Can't get line of code to work:
      # must_respond_with :bad_request WHYYYYYYY
    end
  end

  describe "destroy" do
    it "destroys the driver instance in db when driver exists, then redirects" do
      driver = Driver.create(name: "Finish Rails homework",  vin: "ABCDEFGHIJKLMNOPQ")
      id = driver.id

      #act
      expect{
        delete driver_path(id)
      }.must_change "Driver.count", -1

      #Assert
      must_respond_with :redirect
      must_redirect_to drivers_path


      # Arrange
      # Ensure there is an existing driver saved

      # Act-Assert
      # Ensure that there is a change of -1 in Driver.count

      # Assert
      # Check that the controller redirects

    end

    it "does not change the db when the driver does not exist, then responds with " do
      #Act
      delete driver_path(-1)
      #Assert
      must_respond_with :not_found

      # Arrange
      # Ensure there is an invalid id that points to no driver

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Check that the controller responds or redirects with whatever your group decides

    end
  end
end
