import { LightningElement, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FeedbackForm extends LightningElement {

    // Track the record id and whether the record is saved successfully
    @track recordId;
    @track isRecordSaved = false;

    handleError(event) {
        const evt = new ShowToastEvent({
            title: 'Error!',
            message: event.detail.detail,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);

        this.resetForm();
    }

    handleSuccess(event) {
        this.recordId = event.detail.id;

        this.isRecordSaved = true;

        const even = new ShowToastEvent({
            title: 'Feedback is created!',
            message: 'You can now upload multiple supporting attachments.',
            variant: 'success'
        });

        this.dispatchEvent(even);
    }

    resetForm() {
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }

    // Handle file upload completion
    handleUploadFinished(event) {
        this.isRecordSaved = false;
        const uploadedFiles = event.detail.files;
        const evt = new ShowToastEvent({
            title: 'Success!',
            message: `${uploadedFiles.length} file(s) uploaded successfully!`,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
}