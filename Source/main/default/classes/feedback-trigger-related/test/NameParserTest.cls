@isTest
public class NameParserTest {

    /**
     * Test the full name split 
     */
    @isTest
    static void testExtractNames() {
        // Test case: Full name with both first and last name
        NameParser.FullName result = NameParser.extractNames('Ratna Bhardwaj');
        System.assertEquals('Ratna', result.firstName, 'Invalid first name');
        System.assertEquals('Bhardwaj', result.lastName, 'LAst name is wrong');

        // Test case: Full name with both first and last name
        NameParser.FullName result2 = NameParser.extractNames('Ratna ');
        System.assertEquals('Ratna', result2.firstName, 'Invalid first name');
        System.assertEquals('', result2.lastName, 'LAst name is wrong');
    }
}
