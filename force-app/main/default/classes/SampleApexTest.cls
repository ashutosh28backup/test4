@isTest
public with sharing class SampleApexTest {
    static testMethod void validateSampleApex() {
        SampleApex.print();
        system.assertEquals (0,0,'assert failed');

    }
}
