public class NameParser {

  /**
   * Represents a full name with first and last name components.
   */
  public class FullName {

      private FullName(String fName, String lName) {
          this.firstName = fName;
          this.lastName = lName;
      }

      public String firstName;
      public String lastName;

  }

  /**
   * Extracts first and last name from a full name string.
   *
   * This method assumes the following:
   * - The full name follows the standard format "FirstName LastName".
   * - The name may contain extra spaces before or after.
   * - Only the first two parts of the name are considered.
   *
   * @param fullName The full name string (e.g., "John Doe").
   * @return A FullName object containing the extracted first and last names.
   */
  public static FullName extractNames(String fullName) {
      // Initialize default values
      String firstName = "";
      String lastName = "";

      // Remove leading/trailing whitespace from the input string
      String trimmedFullName = fullName.trim();

      // Split the trimmed full name into parts using a space delimiter
      if (!String.isBlank(trimmedFullName)) {
          String[] nameParts = trimmedFullName.split("\\s+", 2); // Split into at most two parts

          // Assign the first and last names based on the number of parts
          firstName = nameParts.length > 0 ? nameParts[0] : "";
          lastName = nameParts.length > 1 ? nameParts[1] : ""; 
      }

      // Return the FullName object
      return new FullName(firstName, lastName);
  }
}