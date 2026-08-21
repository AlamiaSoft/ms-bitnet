#!/usr/bin/env python3
"""
BitNet Local Docker Smoke Test Client
Tests OpenAI-compatible endpoints on local BitNet inference container.
Zero external pip dependencies (uses standard library urllib, json, time).
"""

import sys
import os
import time
import json
import urllib.request
import urllib.error

def test_models_endpoint(base_url):
    print(f"[1/2] Testing GET {base_url}/v1/models ...")
    req = urllib.request.Request(f"{base_url}/v1/models", method="GET")
    start = time.time()
    try:
        with urllib.request.urlopen(req, timeout=10) as response:
            status = response.getcode()
            body = response.read().decode("utf-8")
            elapsed = time.time() - start
            data = json.loads(body)
            print(f"  -> HTTP Status: {status} (in {elapsed:.3f}s)")
            
            models = data.get("data", [])
            if models:
                model_id = models[0].get("id", "default")
                print(f"  -> Loaded Model ID: {model_id}")
                return model_id
            return "default"
    except urllib.error.URLError as e:
        print(f"  -> ERROR: Failed to connect to {base_url}/v1/models: {e}")
        return None

import re

def detect_repetition(text, threshold=3):
    """Deterministic repetition detector: flags if identical phrases/sentences appear >= threshold times."""
    sentences = [s.strip().lower() for s in re.split(r'[\n\.]+', text) if len(s.strip()) > 5]
    if not sentences:
        return False
    counts = {}
    for s in sentences:
        counts[s] = counts.get(s, 0) + 1
        if counts[s] >= threshold:
            return True
    return False

def test_chat_completion_prompt(base_url, model_id, prompt_title, prompt_text, max_tokens=128):
    print(f"\n--- Testing: {prompt_title} ---")
    print(f"Prompt: {prompt_text}")
    
    payload = {
        "model": model_id or "BitNet-b1.58-2B-4T",
        "messages": [
            {"role": "user", "content": prompt_text}
        ],
        "max_tokens": max_tokens,
        "stop": ["\nQ:", "\nQuestion:", "\nUser:", "Q:", "User:"]
    }
    
    json_data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        f"{base_url}/v1/chat/completions",
        data=json_data,
        headers={"Content-Type": "application/json"},
        method="POST"
    )
    
    start_time = time.time()
    try:
        with urllib.request.urlopen(req, timeout=120) as response:
            status = response.getcode()
            body = response.read().decode("utf-8")
            elapsed_time = time.time() - start_time
            data = json.loads(body)
            
            choice = data.get("choices", [{}])[0]
            message = choice.get("message", {}).get("content", "").strip()
            usage = data.get("usage", {})
            
            prompt_tokens = usage.get("prompt_tokens", len(prompt_text) // 4)
            completion_tokens = usage.get("completion_tokens", len(message) // 4)
            tokens_per_sec = completion_tokens / elapsed_time if elapsed_time > 0 else 0
            has_repetition = detect_repetition(message)
            
            print(f"HTTP Status:          {status}")
            print(f"Generation Time:      {elapsed_time:.2f} seconds")
            print(f"Completion Tokens:    ~{completion_tokens}")
            print(f"Approx Tokens/sec:    {tokens_per_sec:.2f} t/s")
            print(f"Repetition Flag:      {has_repetition}")
            print(f"Response Preview:\n{message[:200]}...")
            
            if not message:
                print("[FAIL] Empty response received.")
                return False
            if has_repetition:
                print("[FAIL] Excessive phrase repetition detected in output.")
                return False
                
            print("[PASS] Coherent non-repetitive response received.")
            return True
    except urllib.error.URLError as e:
        print(f"  -> ERROR: Chat completion failed: {e}")
        return False

def main():
    port = os.environ.get("BITNET_HOST_PORT", "8080")
    base_url = f"http://localhost:{port}"
    
    print("=" * 60)
    print(f" Starting BitNet Smoke & Repetition Quality Tests on {base_url}")
    print("=" * 60)
    
    model_id = test_models_endpoint(base_url)
    if not model_id:
        print("\n[FAILED] Server is not responding. Ensure container is running via `scripts/start.ps1`")
        sys.exit(1)
        
    test_cases = [
        ("Test 1: Greeting ('hi')", "hi", 64),
        ("Test 2: Restaurant Definition", "Explain what a restaurant is in one sentence.", 64),
        ("Test 3: Architecture Domain", "Explain a restaurant SaaS in two sentences.", 96)
    ]
    
    all_passed = True
    for title, prompt, max_t in test_cases:
        passed = test_chat_completion_prompt(base_url, model_id, title, prompt, max_tokens=max_t)
        if not passed:
            all_passed = False
            
    print("\n" + "=" * 60)
    if all_passed:
        print("[SUCCESS] All BitNet smoke & quality tests passed successfully!")
        sys.exit(0)
    else:
        print("[FAILED] One or more quality/repetition tests failed.")
        sys.exit(1)

if __name__ == "__main__":
    main()
