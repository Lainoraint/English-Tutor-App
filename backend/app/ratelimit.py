from collections import defaultdict
from datetime import date
from typing import Dict, Tuple

class RateLimiter:
    def __init__(self):
        # Maps device_id to (date, count)
        self.usage: Dict[str, Tuple[date, int]] = defaultdict(lambda: (date.today(), 0))
    
    def check_and_increment(self, device_id: str, limit: int) -> bool:
        today = date.today()
        current_date, count = self.usage[device_id]
        
        if current_date != today:
            count = 0
            
        if count >= limit:
            # Update the stored date in case they were checked yesterday but failed today
            self.usage[device_id] = (today, count)
            return False
            
        self.usage[device_id] = (today, count + 1)
        return True

limiter = RateLimiter()
