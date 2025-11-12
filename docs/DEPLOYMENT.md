# Shongkot Backend Deployment Guide

## Overview

This guide provides step-by-step instructions for deploying the Shongkot backend API to Render.com's free tier, giving you a publicly accessible URL.

## Prerequisites

- GitHub repository access
- Render.com account (free tier available)
- Git installed locally (optional, for manual deployment)

## Deployment Options

### Option 1: One-Click Deploy with Render Blueprint (Recommended)

The easiest way to deploy is using the `render.yaml` blueprint file already configured in the repository.

1. **Sign up for Render.com**
   - Go to https://render.com
   - Click "Get Started" and sign up with your GitHub account
   - Authorize Render to access your repositories

2. **Deploy from Blueprint**
   - Go to https://dashboard.render.com/select-repo
   - Click "Connect account" if needed
   - Select the `omar-khaium/shongkot` repository
   - Render will automatically detect the `render.yaml` file
   - Click "Apply" to create the service

3. **Wait for Deployment**
   - Render will automatically:
     - Build the Docker image from `backend/Dockerfile`
     - Deploy the container
     - Assign a public URL
   - Initial deployment takes 5-10 minutes

4. **Access Your API**
   - Your API will be available at: `https://shongkot-api.onrender.com`
   - Health check: `https://shongkot-api.onrender.com/health`
   - Swagger UI: `https://shongkot-api.onrender.com/swagger`

### Option 2: Manual Render Deployment

If you prefer manual configuration:

1. **Create New Web Service**
   - Log in to Render.com
   - Click "New" → "Web Service"
   - Connect your GitHub account if not already connected
   - Select the `omar-khaium/shongkot` repository

2. **Configure Service**
   - **Name**: `shongkot-api` (or your preferred name)
   - **Region**: Choose closest to you (e.g., Oregon, Frankfurt)
   - **Branch**: `main`
   - **Runtime**: Docker
   - **Dockerfile Path**: `./backend/Dockerfile`
   - **Docker Context**: `./backend`
   - **Plan**: Free

3. **Environment Variables** (optional)
   ```
   ASPNETCORE_ENVIRONMENT=Production
   ASPNETCORE_URLS=http://+:8080
   ```

4. **Health Check Configuration**
   - **Health Check Path**: `/health`

5. **Deploy**
   - Click "Create Web Service"
   - Wait for the build and deployment to complete

## CI/CD Integration

The repository includes a GitHub Actions workflow (`.github/workflows/backend-cicd.yml`) that:

1. ✅ Runs on every push to `main` or `develop` branches
2. ✅ Builds the .NET solution
3. ✅ Runs all unit and integration tests
4. ✅ Builds and tests the Docker image
5. ✅ Provides deployment instructions

### Automatic Deployment on Push

Render.com automatically redeploys when you push to the connected branch (main):

```bash
git add .
git commit -m "Update API"
git push origin main
```

Render will detect the push and automatically rebuild and redeploy your service.

## Free Tier Limitations

Render.com's free tier includes:

- ✅ 750 hours of runtime per month (enough for always-on)
- ✅ Automatic HTTPS with SSL certificates
- ✅ Custom domains (optional)
- ✅ Automatic deploys from Git
- ⚠️ Services spin down after 15 minutes of inactivity
- ⚠️ First request after sleep may take 30-60 seconds

**Note**: The API will "sleep" after 15 minutes of no activity and wake up on the next request. For production use, consider upgrading to a paid plan.

## Verifying Deployment

After deployment, test your API:

### 1. Health Check
```bash
curl https://shongkot-api.onrender.com/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2025-11-11T17:20:00Z",
  "version": "1.0.0"
}
```

### 2. Swagger UI
Open in browser:
```
https://shongkot-api.onrender.com/swagger
```

You should see the interactive API documentation with all available endpoints.

### 3. Test Emergency Endpoint
```bash
curl -X GET https://shongkot-api.onrender.com/api/emergency/12345
```

## Monitoring and Logs

### View Logs in Render Dashboard
1. Go to https://dashboard.render.com
2. Select your `shongkot-api` service
3. Click "Logs" tab to see real-time application logs

### Key Metrics
- **Deploy Time**: Available in the Events tab
- **Response Time**: Monitor via Render metrics
- **Uptime**: Free tier services sleep after inactivity

## Troubleshooting

### Service Won't Start
1. Check logs in Render dashboard
2. Verify Dockerfile builds locally:
   ```bash
   cd backend
   docker build -t test .
   docker run -p 8080:8080 test
   ```

### Health Check Failing
- Ensure `/health` endpoint is responding
- Check port 8080 is exposed in Dockerfile
- Verify `ASPNETCORE_URLS=http://+:8080` is set

### Slow First Request
- This is normal for free tier (cold start)
- Consider upgrading to paid plan for always-on service
- Or use a cron job to ping the API every 10 minutes

## Alternative Free Hosting Options

If Render doesn't meet your needs, consider:

1. **Railway.app**: Similar to Render, 500 hours free/month
2. **Fly.io**: Free tier with 3 shared VMs
3. **Azure App Service**: Free tier with limitations
4. **Google Cloud Run**: Free tier with generous limits

## Security Considerations

For production deployment:

1. ✅ HTTPS is enabled by default on Render
2. ⚠️ CORS is currently set to `AllowAll` - restrict in production
3. ⚠️ No authentication - add JWT or OAuth before production
4. ⚠️ No rate limiting - consider adding for production
5. ⚠️ No database - configure when needed

## Next Steps

1. **Custom Domain**: Add your own domain in Render settings
2. **Environment Variables**: Store secrets in Render dashboard
3. **Database**: Add PostgreSQL (also free tier available)
4. **Caching**: Configure Redis if needed
5. **Monitoring**: Set up Sentry or similar for error tracking

## Support

For deployment issues:
- Render Documentation: https://render.com/docs
- Render Community: https://community.render.com
- GitHub Issues: https://github.com/omar-khaium/shongkot/issues

## Cost Estimate

**Free Tier**: $0/month
- Perfect for development, testing, and low-traffic APIs
- Automatic HTTPS included
- Auto-sleep after 15 min inactivity

**Starter Tier**: $7/month (when ready for production)
- Always-on service (no sleep)
- Faster startup times
- Priority support

---

**Last Updated**: November 11, 2025
