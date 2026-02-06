-- KaamChalu B2B Automation Platform
-- Row Level Security Policies
-- Multi-tenant security via organization_id

-- Enable RLS on all tables
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.integrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workflows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workflow_steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workflow_runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workflow_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.billing ENABLE ROW LEVEL SECURITY;

-- ============================================
-- Helper function to get user's organization IDs
-- ============================================
CREATE OR REPLACE FUNCTION get_user_org_ids()
RETURNS SETOF UUID AS $$
BEGIN
  RETURN QUERY
  SELECT organization_id FROM public.members
  WHERE user_id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- Organizations Policies
-- ============================================
CREATE POLICY "Users can view their organizations"
  ON public.organizations FOR SELECT
  USING (id IN (SELECT get_user_org_ids()));

CREATE POLICY "Owners can update their organizations"
  ON public.organizations FOR UPDATE
  USING (id IN (
    SELECT organization_id FROM public.members
    WHERE user_id = auth.uid() AND role = 'owner'
  ));

-- ============================================
-- Users Policies
-- ============================================
CREATE POLICY "Users can view themselves"
  ON public.users FOR SELECT
  USING (id = auth.uid());

CREATE POLICY "Users can update themselves"
  ON public.users FOR UPDATE
  USING (id = auth.uid());

CREATE POLICY "Users can insert themselves"
  ON public.users FOR INSERT
  WITH CHECK (id = auth.uid());

-- ============================================
-- Members Policies
-- ============================================
CREATE POLICY "Users can view members of their orgs"
  ON public.members FOR SELECT
  USING (organization_id IN (SELECT get_user_org_ids()));

CREATE POLICY "Admins can manage members"
  ON public.members FOR ALL
  USING (organization_id IN (
    SELECT organization_id FROM public.members
    WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
  ));

-- ============================================
-- Integrations Policies
-- IMPORTANT: Credentials are only accessible via Edge Functions
-- ============================================
CREATE POLICY "Users can view integration status (not credentials)"
  ON public.integrations FOR SELECT
  USING (organization_id IN (SELECT get_user_org_ids()));

-- Note: INSERT/UPDATE handled by Edge Functions with service role

-- ============================================
-- Workflows Policies
-- ============================================
CREATE POLICY "Users can view workflows in their orgs"
  ON public.workflows FOR SELECT
  USING (organization_id IN (SELECT get_user_org_ids()));

CREATE POLICY "Admins can manage workflows"
  ON public.workflows FOR ALL
  USING (organization_id IN (
    SELECT organization_id FROM public.members
    WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
  ));

-- ============================================
-- Workflow Steps Policies
-- ============================================
CREATE POLICY "Users can view workflow steps"
  ON public.workflow_steps FOR SELECT
  USING (workflow_id IN (
    SELECT id FROM public.workflows
    WHERE organization_id IN (SELECT get_user_org_ids())
  ));

-- Note: Steps are system-managed, not user-editable

-- ============================================
-- Workflow Runs Policies
-- ============================================
CREATE POLICY "Users can view runs in their orgs"
  ON public.workflow_runs FOR SELECT
  USING (workflow_id IN (
    SELECT id FROM public.workflows
    WHERE organization_id IN (SELECT get_user_org_ids())
  ));

CREATE POLICY "Users can trigger runs"
  ON public.workflow_runs FOR INSERT
  WITH CHECK (workflow_id IN (
    SELECT id FROM public.workflows
    WHERE organization_id IN (SELECT get_user_org_ids())
  ));

-- ============================================
-- Workflow Logs Policies
-- ============================================
CREATE POLICY "Users can view logs for their runs"
  ON public.workflow_logs FOR SELECT
  USING (run_id IN (
    SELECT wr.id FROM public.workflow_runs wr
    JOIN public.workflows w ON wr.workflow_id = w.id
    WHERE w.organization_id IN (SELECT get_user_org_ids())
  ));

-- ============================================
-- Billing Policies
-- ============================================
CREATE POLICY "Users can view billing for their orgs"
  ON public.billing FOR SELECT
  USING (organization_id IN (SELECT get_user_org_ids()));

CREATE POLICY "Users can create billing requests"
  ON public.billing FOR INSERT
  WITH CHECK (organization_id IN (SELECT get_user_org_ids()));

-- Note: Status updates handled by admin/webhooks via service role
