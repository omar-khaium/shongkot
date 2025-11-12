# Quick Start: Deploy Shongkot Backend to Render.com

This guide gets your backend API deployed and publicly accessible in under 10 minutes.

## Prerequisites
- GitHub account with access to this repository
- Render.com account (sign up free at https://render.com)

## Deployment Steps

### 1. Sign Up for Render (2 minutes)
1. Go to https://render.com
2. Click "Get Started" or "Sign Up"
3. Choose "Sign in with GitHub"
4. Authorize Render to access your repositories

### 2. Deploy with Blueprint (5 minutes)
1. Go to https://dashboard.render.com/select-repo
2. Select the `omar-khaium/shongkot` repository
3. Render will detect `render.yaml` automatically
4. Review the configuration:
   - Service Name: shongkot-api
   - Region: Oregon (or choose closest to you)
   - Plan: Free
5. Click "Apply" to create the service
6. Wait for the build to complete (5-8 minutes)

### 3. Get Your Public URL (1 minute)
Once deployed, you'll receive a URL like:
```
https://shongkot-api.onrender.com
```

### 4. Test Your API
Open in your browser:
```
https://shongkot-api.onrender.com/swagger
```

Or test with curl:
```bash
curl https://shongkot-api.onrender.com/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2025-11-11T17:30:00Z",
  "version": "1.0.0"
}
```

## What's Included

Your deployed API includes:
- ✅ RESTful API endpoints
- ✅ Swagger/OpenAPI documentation
- ✅ Health check endpoint
- ✅ HTTPS enabled by default
- ✅ Auto-deploy on git push to main
- ✅ Free hosting (with limitations)

## Important Notes

### Free Tier Limitations
- Service sleeps after 15 minutes of inactivity
- First request after sleep takes 30-60 seconds (cold start)
- 750 hours/month runtime (enough for always-on in off-peak)

### Automatic Deployments
Every push to `main` branch automatically triggers a new deployment:
```bash
git add .
git commit -m "Update API"
git push origin main
```

### Monitoring
- View logs: https://dashboard.render.com → Select service → Logs
- View metrics: Dashboard → Select service → Metrics

## Troubleshooting

**Service won't start?**
- Check logs in Render dashboard
- Verify GitHub Actions workflow passed

**Health check failing?**
- Wait a few minutes for full deployment
- Check service status in dashboard
- Review deployment logs

**Slow response?**
- Service is waking from sleep (normal for free tier)
- Subsequent requests will be fast
- Consider upgrading to paid plan for always-on

## Next Steps

1. **Connect Mobile App**: Update mobile app to use your new API URL
2. **Custom Domain**: Add your domain in Render settings (optional)
3. **Database**: Add PostgreSQL when needed (also free tier available)
4. **Environment Variables**: Add secrets in Render dashboard

## Support

- Full deployment guide: [docs/DEPLOYMENT.md](DEPLOYMENT.md)
- Render docs: https://render.com/docs
- Issues: https://github.com/omar-khaium/shongkot/issues

---

**Deployment Time**: ~10 minutes
**Cost**: Free
**Public URL**: Automatically provided
