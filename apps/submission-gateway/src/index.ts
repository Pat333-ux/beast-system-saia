import express, { Request, Response } from 'express';

const app = express();
const PORT = process.env.PORT || 8080;

app.use(express.json());

// Health Check Endpoint
app.get('/health', (req: Request, res: Response) => {
  res.status(200).json({ 
    status: 'OK', 
    system: 'BEAST-SAIA Submission Gateway', 
    timestamp: new Date().toISOString() 
  });
});

// Intake / Public Submission Endpoint
app.post('/api/v1/submissions', async (req: Request, res: Response) => {
  try {
    const submissionData = req.body;
    
    if (!submissionData || !submissionData.applicantId || !submissionData.programId) {
      return res.status(400).json({ error: 'Missing required submission parameters (applicantId, programId).' });
    }

    const trackingId = `SAIA-SUB-${Date.now()}`;
    
    console.log(`[SAIA Submissions] Received payload ${trackingId} for applicant ${submissionData.applicantId}`);

    return res.status(201).json({
      success: true,
      trackingId,
      status: 'QUEUED_FOR_EVALUATION',
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Submission handling error:', error);
    return res.status(500).json({ error: 'Internal system gateway error.' });
  }
});

app.listen(PORT, () => {
  console.log(`[BEAST SAIA] Submission Gateway listening on port ${PORT}`);
});
