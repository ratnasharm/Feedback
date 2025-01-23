public class NameParser {

  public class FullName {
      
    private FullName(String fName, String lName){
      this.firstName = fName;
      this.lastName = lName;
    }

    public String firstName;
    public String lastName;

  }

  /**
   * Method to extract first name and last name from a full name
   * @param fullName The full name string (e.g., "John Doe")
   * @return A map with keys 'FirstName' and 'LastName'
   */
  public static FullName extractNames(String fullName) {
      // Initialize default values
      String firstName = '';
      String lastName = '';

      // Split the full name into parts
      if (!String.isBlank(fullName)) {
          String[] nameParts = fullName.trim().split(' ', 2); // Split into two parts
          
          // Assign the first and last names based on the parts
          firstName = nameParts.size() > 0 ? nameParts[0] : '';
          lastName = nameParts.size() > 1 ? nameParts[1] : ''; // If no last name, keep it empty
      }

      // Return the fullName Object
      return new FullName(firstName, lastName);
  }
}
