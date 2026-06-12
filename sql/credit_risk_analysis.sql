-- ==========================================================
-- CREDIT RISK ANALYSIS PROJECT
-- ==========================================================
--
-- Objective:
-- Analyze a portfolio of 25,000 loans to understand
-- borrower risk, portfolio composition, loan performance,
-- and financial exposure.
--
-- Business Goals:
-- 1. Assess overall portfolio health
-- 2. Evaluate effectiveness of risk segmentation
-- 3. Identify high-risk borrower groups
-- 4. Understand loan demand patterns
-- 5. Measure portfolio exposure across risk tiers
--
-- Tools Used:
-- PostgreSQL
-- SQL
-- Power BI
--
-- Dataset:
-- 25,000 Loan Records
--
-- Author:
-- Shadab Kazi
--
-- ==========================================================


-- ====================================================
-- Q1. Portfolio Summary
--
-- Business Question:
-- What is the overall size, value, and credit quality
-- of the loan portfolio?
--
-- Why This Matters:
-- Before performing any risk analysis, management needs
-- a high-level view of portfolio exposure, pricing,
-- and borrower quality.
-- ====================================================

SELECT
    COUNT(*) AS total_loans,
    SUM(funded_amount) AS total_portfolio_value,
    ROUND(AVG(int_rate), 2) AS avg_interest_rate,
    ROUND(AVG(fico_score), 0) AS avg_fico_score
FROM credit_risk_loans;

-- ====================================================
-- Key Findings:
-- Total Loans: 25,000
-- Portfolio Value: $501.75 Million
-- Average Interest Rate: 15.50%
-- Average FICO Score: 680
--
-- Conclusion:
-- The portfolio consists of 25,000 loans with moderate
-- credit quality and an average interest rate of 15.5%.
-- ====================================================


-- ====================================================
-- Q2. Loan Status Distribution
--
-- Business Question:
-- What percentage of loans are fully paid versus
-- defaulted?
--
-- Why This Matters:
-- Loan performance is a key indicator of portfolio
-- health and overall credit quality.
-- ====================================================

SELECT
    loan_status,
    COUNT(*) AS loan_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM credit_risk_loans),
        2
    ) AS percentage
FROM credit_risk_loans
GROUP BY loan_status
ORDER BY loan_count DESC;

-- ====================================================
-- Key Findings:
-- Fully Paid loans represent the majority of the
-- portfolio.
-- Defaulted loans account for approximately 11.38%.
--
-- Conclusion:
-- The portfolio demonstrates strong repayment behavior,
-- with most borrowers successfully completing their loans.
-- ====================================================


-- ====================================================
-- Q3. Risk Tier Distribution
--
-- Business Question:
-- How is the portfolio distributed across risk levels?
--
-- Why This Matters:
-- Understanding risk concentration helps lenders assess
-- overall portfolio exposure.
-- ====================================================

SELECT
    risk_tier,
    COUNT(*) AS loan_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM credit_risk_loans),
        2
    ) AS percentage
FROM credit_risk_loans
GROUP BY risk_tier
ORDER BY loan_count DESC;

-- ====================================================
-- Key Findings:
-- Medium Risk: 44.03%
-- High Risk: 34.16%
-- Low Risk: 21.82%
--
-- Conclusion:
-- The portfolio is concentrated in Medium Risk borrowers,
-- followed by High Risk borrowers.
-- ====================================================


-- ====================================================
-- Q4. Average Interest Rate by Risk Tier
--
-- Business Question:
-- Are higher-risk borrowers charged higher interest
-- rates?
--
-- Why This Matters:
-- Lenders use risk-based pricing to compensate for
-- increased default risk.
-- ====================================================

SELECT
    risk_tier,
    ROUND(AVG(int_rate), 2) AS avg_interest_rate
FROM credit_risk_loans
GROUP BY risk_tier
ORDER BY avg_interest_rate DESC;

-- ====================================================
-- Key Findings:
-- High Risk: 16.85%
-- Medium Risk: 15.30%
-- Low Risk: 13.79%
--
-- Conclusion:
-- Interest rates increase as borrower risk increases,
-- confirming an effective risk-based pricing strategy.
-- ====================================================


-- ====================================================
-- Q5. Average FICO Score by Risk Tier
--
-- Business Question:
-- Does risk classification align with borrower credit
-- quality?
--
-- Why This Matters:
-- FICO score is a key measure of creditworthiness and
-- should vary across risk categories.
-- ====================================================

SELECT
    risk_tier,
    ROUND(AVG(fico_score), 0) AS avg_fico_score
FROM credit_risk_loans
GROUP BY risk_tier
ORDER BY avg_fico_score DESC;

-- ====================================================
-- Key Findings:
-- Low Risk: 748
-- Medium Risk: 688
-- High Risk: 626
--
-- Conclusion:
-- Borrowers classified as Low Risk have significantly
-- stronger credit profiles than High Risk borrowers.
-- ====================================================


-- ====================================================
-- Q6. Default Rate by Risk Tier
--
-- Business Question:
-- Which risk segment experiences the highest default
-- rates?
--
-- Why This Matters:
-- Default rate measures the effectiveness of the
-- institution's risk classification model.
-- ====================================================

SELECT
    risk_tier,
    COUNT(*) AS total_loans,
    SUM(
        CASE
            WHEN loan_status = 'Default' THEN 1
            ELSE 0
        END
    ) AS defaults,
    ROUND(
        SUM(
            CASE
                WHEN loan_status = 'Default' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS default_rate
FROM credit_risk_loans
GROUP BY risk_tier
ORDER BY default_rate DESC;

-- ====================================================
-- Key Findings:
-- High Risk: 13.54%
-- Medium Risk: 10.82%
-- Low Risk: 9.13%
--
-- Conclusion:
-- Default rates increase with borrower risk,
-- validating the effectiveness of the risk model.
-- ====================================================


-- ====================================================
-- Q7. Loan Purpose Distribution
--
-- Business Question:
-- What are the primary reasons borrowers take loans?
--
-- Why This Matters:
-- Understanding borrower demand helps institutions
-- optimize lending products.
-- ====================================================

SELECT
    purpose,
    COUNT(*) AS loan_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM credit_risk_loans),
        2
    ) AS percentage
FROM credit_risk_loans
GROUP BY purpose
ORDER BY loan_count DESC;

-- ====================================================
-- Key Findings:
-- Debt Consolidation: 49.89%
-- Credit Card Refinance: 19.64%
-- Home Improvement: 15.32%
-- Major Purchase: 10.17%
-- Small Business: 4.98%
--
-- Conclusion:
-- Debt Consolidation is the dominant loan purpose,
-- accounting for nearly half of all loans.
-- ====================================================


-- ====================================================
-- Q8. Home Ownership Distribution
--
-- Business Question:
-- What is the home ownership profile of borrowers?
--
-- Why This Matters:
-- Home ownership often reflects financial stability
-- and borrower demographics.
-- ====================================================

SELECT
    home_ownership,
    COUNT(*) AS loan_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM credit_risk_loans),
        2
    ) AS percentage
FROM credit_risk_loans
GROUP BY home_ownership
ORDER BY loan_count DESC;

-- ====================================================
-- Key Findings:
-- Mortgage: 49.87%
-- Rent: 40.09%
-- Own: 10.04%
--
-- Conclusion:
-- Most borrowers either hold a mortgage or rent,
-- indicating active housing-related financial obligations.
-- ====================================================


-- ====================================================
-- Q9. Default Rate by Loan Purpose
--
-- Business Question:
-- Which loan purposes are associated with the highest
-- default risk?
--
-- Why This Matters:
-- Identifying high-risk products helps improve
-- underwriting and lending decisions.
-- ====================================================

SELECT
    purpose,
    COUNT(*) AS total_loans,
    SUM(
        CASE
            WHEN loan_status = 'Default' THEN 1
            ELSE 0
        END
    ) AS defaults,
    ROUND(
        SUM(
            CASE
                WHEN loan_status = 'Default' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS default_rate
FROM credit_risk_loans
GROUP BY purpose
ORDER BY default_rate DESC;

-- ====================================================
-- Key Findings:
-- Small Business loans show the highest default rate
-- at 15.58%.
--
-- Conclusion:
-- Small Business lending represents the riskiest
-- loan category in the portfolio.
-- ====================================================


-- ====================================================
-- Q10. Portfolio Value by Risk Tier
--
-- Business Question:
-- Which risk segment contributes the largest share of
-- portfolio value?
--
-- Why This Matters:
-- Financial exposure is determined by capital deployed,
-- not just the number of loans.
-- ====================================================

SELECT
    risk_tier,
    COUNT(*) AS total_loans,
    SUM(funded_amount) AS portfolio_value,
    ROUND(AVG(funded_amount), 0) AS avg_loan_amount
FROM credit_risk_loans
GROUP BY risk_tier
ORDER BY portfolio_value DESC;

-- ====================================================
-- Key Findings:
-- Medium Risk: $219.32 Million
-- High Risk: $172.05 Million
-- Low Risk: $110.38 Million
--
-- Average Loan Amount:
-- Medium Risk: $19,926
-- High Risk: $20,149
-- Low Risk: $20,237
--
-- Conclusion:
-- Medium Risk borrowers contribute the largest share
-- of portfolio value and represent the greatest area
-- of financial exposure.
-- ====================================================


-- ====================================================
-- Q11. Average Debt-to-Income (DTI) Ratio by Risk Tier
--
-- Business Question:
-- Do higher-risk borrowers carry higher debt burdens
-- relative to their income?
--
-- Why This Matters:
-- Debt-to-Income (DTI) ratio is a critical credit risk
-- metric used by lenders to evaluate a borrower's ability
-- to manage monthly debt payments. Higher DTI values
-- typically indicate greater financial stress and a
-- higher probability of default.
-- ====================================================

SELECT
    risk_tier,
    ROUND(AVG(dti), 2) AS avg_dti
FROM credit_risk_loans
GROUP BY risk_tier
ORDER BY avg_dti DESC;

-- ====================================================
-- Key Findings:
-- Medium Risk: 0.30
-- Low Risk: 0.30
-- High Risk: 0.30
--
-- Conclusion:
-- Average Debt-to-Income (DTI) ratios are nearly
-- identical across all risk tiers, suggesting that
-- debt burden alone is not a major differentiator
-- within the portfolio's risk classification model.
--
-- This indicates that other factors such as FICO
-- score, repayment history, and credit behavior may
-- play a larger role in determining borrower risk.
-- ====================================================



-- ==========================================================
-- EXECUTIVE SUMMARY
-- ==========================================================
--
-- Key Insights:
--
-- 1. Medium Risk borrowers represent the largest
--    segment of the portfolio (44.03%).
--
-- 2. High Risk borrowers pay the highest interest
--    rates (16.85%).
--
-- 3. Default rates increase with borrower risk,
--    validating the risk classification model.
--
-- 4. Debt Consolidation accounts for nearly 50%
--    of all loans.
--
-- 5. Small Business loans exhibit the highest
--    default rate (15.58%).
--
-- 6. Medium Risk borrowers contribute the largest
--    share of portfolio value ($219.32 Million).
--
-- ==========================================================
